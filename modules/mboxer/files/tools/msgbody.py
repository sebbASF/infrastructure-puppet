#!/usr/bin/env python3

""" Quick lib for fetching an email's body text, borrowed from pony mail """
def get_body(msg):
    body = None
    first_html = None
    for part in msg.walk():
        # can be called from importer
        try:
            if not body and part.get_content_type() == 'text/plain':
                body = part.get_payload(decode=True)
            if not body and part.get_content_type() == 'text/enriched':
                body = part.get_payload(decode=True)
            elif not first_html and part.get_content_type() == 'text/html':
                first_html = part.get_payload(decode=True)
        except Exception as err:
            print(err)

    # Prefer text/plain, fall back to text/html if nothing else available
    if not body and first_html:
        body = first_html

    # This code will try at most one charset
    # If the decode fails, it will use utf-8
    for charset in get_charsets(msg):
        try:
            body = body.decode(charset) if type(body) is bytes else body
            # at this point body can no longer be bytes
        except:
            body = body.decode('utf-8', errors='replace') if type(body) is bytes else body
            # at this point body can no longer be bytes

    return body


def get_charsets(msg):
    charsets = set({})
    for c in msg.get_charsets():
        if c is not None:
            charsets.update([c])
    return charsets
