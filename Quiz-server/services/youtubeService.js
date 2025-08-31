import { YoutubeTranscript } from 'youtube-transcript';

/**
 * Extract video ID from YouTube URL and fetch transcript
 * @param {string} youtubeUrl
 * @returns {Promise<string>}
 */
export async function getTranscriptFromYoutube(youtubeUrl) {
    try {
        // Extract video ID from the given URL
        const videoId = extractVideoId(youtubeUrl);
        if (!videoId) {
            throw new Error('Invalid YouTube URL');
        }

        // Fetch transcript
        const transcript = await YoutubeTranscript.fetchTranscript(videoId);

        // Combine transcript text into a single string
        return transcript.map(item => item.text).join(' ');
    } catch (error) {
        throw new Error(`Failed to get transcript: ${error.message}`);
    }
}

/**
 * Extracts the video ID from a YouTube URL
 * @param {string} url
 * @returns {string|null}
 */
function extractVideoId(url) {
    const regex = /(?:v=|\/)([0-9A-Za-z_-]{11})/;
    const match = url.match(regex);
    return match ? match[1] : null;
}
