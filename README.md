# yt-desc-links
Scrape image and thumbnail links from YouTube videos

    NAME
        yt-desc-links - display links to thumbnail image and links from
        description

    SYNOPSIS
            yt-desc-links [OPTION]...

            -f, --[no]filter  only display links from common image sites (e.g., pixiv)
            -k, --api-key     set the YouTube API key
            --help            display this help message

    DESCRIPTION
        Accepts YouTube video IDs or watch URLs from stdin, and prints the ID,
        followed by the thumbnail link, followed by description links, to
        stdout.

        An API key is required to access the YouTube Data API. It may be
        specified on the command line ("-k") or by environment variable
        ("YT_API_KEY").

    AUTHOR
        Aaron L. Zeng <me@bcc32.com>
