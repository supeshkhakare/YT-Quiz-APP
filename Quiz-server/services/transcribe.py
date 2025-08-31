from youtube_transcript_api import YouTubeTranscriptApi
import sys
import json

def get_transcript(video_url):
    try:
        # Video ID extract karna
        if "v=" in video_url:
            video_id = video_url.split("v=")[1].split("&")[0]
        else:
            video_id = video_url

        ytt_api = YouTubeTranscriptApi()
        transcript_list = ytt_api.list(video_id)

        # English transcript find karna
        transcript = transcript_list.find_transcript(['en'])
        transcript_data = transcript.fetch()

        # Join all text from objects
        transcript_text = " ".join([t.text for t in transcript_data])

        print(json.dumps({"transcript": transcript_text}, ensure_ascii=False))
    except Exception as e:
        print(json.dumps({"error": str(e)}))

if __name__ == "__main__":
    get_transcript(sys.argv[1])
