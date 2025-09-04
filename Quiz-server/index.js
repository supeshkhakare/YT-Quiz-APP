import { spawn } from 'child_process';
import express from 'express';
import { generateQuizFromTranscript } from './services/geminiService.js';

const app = express();
app.use(express.json());

app.post('/transcript', (req, res) => {
    const videoUrl = req.body.video_url;
    if (!videoUrl) return res.status(400).json({ error: 'video_url is required' });

    const pythonProcess = spawn('python', ['services/transcribe.py', videoUrl]);

    let output = '';
    let errorOutput = '';

    pythonProcess.stdout.on('data', (data) => { output += data.toString(); });
    pythonProcess.stderr.on('data', (data) => { errorOutput += data.toString(); });

    pythonProcess.on('close', async (code) => {
        if (code !== 0 || errorOutput) {
            console.error('Python error:', errorOutput);
            return res.status(500).json({ error: errorOutput || 'Python script failed' });
        }

        try {
            const parsedOutput = JSON.parse(output);
            const transcriptText = parsedOutput.transcript || '';
            if (!transcriptText) return res.status(400).json({ error: 'No transcript found' });

            const quiz = await generateQuizFromTranscript(transcriptText);

           
            res.json(quiz);

        } catch (err) {
            console.error("Error processing quiz:", err);
            res.status(500).json({ error: 'Failed to process transcript/quiz', details: err.message });
        }
    });
});

app.listen(4000, () => console.log('Server running on port 4000'));
