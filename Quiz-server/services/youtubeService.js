import { YoutubeTranscript } from 'youtube-transcript';


export async function getTranscriptFromYoutube(youtubeUrl) {
    try {
       
        const videoId = extractVideoId(youtubeUrl);
        if (!videoId) {
            throw new Error('Invalid YouTube URL');
        }

      
        const transcript = await YoutubeTranscript.fetchTranscript(videoId);

       
        return transcript.map(item => item.text).join(' ');
    } catch (error) {
        throw new Error(`Failed to get transcript: ${error.message}`);
    }
}


function extractVideoId(url) {
    const regex = /(?:v=|\/)([0-9A-Za-z_-]{11})/;
    const match = url.match(regex);
    return match ? match[1] : null;
}
