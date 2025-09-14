import { GoogleGenAI } from "@google/genai";
import dotenv from "dotenv";

dotenv.config();

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

function cleanTranscript(text) {
    return text
        .replace(/\[\d{2}:\d{2}(:\d{2})?\]/g, "")
        .replace(/\b(uh|um|you know|like)\b/gi, "")
        .replace(/Speaker \d+:/gi, "")
        .replace(/\s+/g, " ")
        .trim();
}

function chunkText(text, maxLength = 1600) {
    const chunks = [];
    let start = 0;
    while (start < text.length) {
        let end = start + maxLength;
        const periodPos = text.lastIndexOf('.', end);
        if (periodPos > start) end = periodPos + 1;
        chunks.push(text.slice(start, end).trim());
        start = end;
    }
    return chunks;
}

async function generateText(prompt) {
    const response = await ai.models.generateContent({
        model: "gemini-2.5-flash",
        contents: prompt,
    });
    return response.text;
}

async function summarizeTranscript(transcript) {
    const cleaned = cleanTranscript(transcript);
    const chunks = chunkText(cleaned);
    const allSummaries = [];

    for (let i = 0; i < chunks.length; i++) {
        const summaryPrompt = `Summarize in 3-5 bullet points, key facts only:\n${chunks[i]}`;
        const summary = await generateText(summaryPrompt);
        allSummaries.push(summary);
    }

    const finalPrompt = `Combine into max 7 bullet points, remove duplicates:\n${allSummaries.join("\n")}`;
    return await generateText(finalPrompt);
}

export async function generateQuizFromTranscript(transcript) {
    try {
        const summarizedTranscript = await summarizeTranscript(transcript);

        const quizPrompt = `
Make 5 MCQs from text.
Format strictly:
{"quiz":[{"question":"Q?","options":["A","B","C","D"],"correctIndex":n}]}
- 4 options only
- correctIndex = 0-3
- No extra text, only JSON

Text:
${summarizedTranscript}
`;

        let quizText = await generateText(quizPrompt);

      
        quizText = quizText.replace(/```json|```/g, '').trim();

       
        const quizJson = typeof quizText === 'string' ? JSON.parse(quizText) : quizText;

        return quizJson;

    } catch (error) {
        console.error("Gemini API Error:", error);
        throw new Error("Failed to generate quiz");
    }
}
