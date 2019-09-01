def is_anagram(message1, message2):
    return sorted(message1.replace(' ','')) == sorted(message2.replace(' ', ''))
