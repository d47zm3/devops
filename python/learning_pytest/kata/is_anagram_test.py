from .is_anagram import is_anagram
import pytest


def test_initial():
    assert is_anagram('test', 'test')


@pytest.mark.parametrize('message1, message2', (
        ('test', 'not test'),
        ('not test', 'test'),
        ('true', 'false'),
        ('test', 'tessst')
))
def test_not_anagram(message1, message2):
    assert not is_anagram(message1, message2)

@pytest.mark.parametrize('message1, message2', (
        ('test','tets'),
        ('cart horse', 'orchestra')
))
def test_real_anagram(message1, message2):
    assert is_anagram(message1, message2)