module MusixMatch
  module InstantLyrics
    class Result
      attr_reader :lyrics

      def initialize(lyrics)
        @lyrics = lyrics
      end

      def found?
        @lyrics.is_a?(MusixMatch::Models::Lyrics)      
      end
    end

    class Search
      def initialize(q)
        @q = q
      end

      def start
        lyrics_id = search_track
        lyrics    = find_lyrics(lyrics_id) if lyrics_id
        Result.new(lyrics)
      end

      def search_track
        result = MusixMatch.search_track(:q => @q, :f_has_lyrics => 1)
        if result.status_code == 200 && lyrics = result.track_list.first
          lyrics.lyrics_id
        end
      end

      def find_lyrics(lyrics_id)
        result = MusixMatch.get_lyrics(lyrics_id)
        if result.status_code == 200 && lyrics = result.lyrics
          lyrics
        end
      end

      def self.search(q)
        s = Search.new(q).start
      end
    end
  end
end