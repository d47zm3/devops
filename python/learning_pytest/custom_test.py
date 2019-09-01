import pytest
import os


@pytest.mark.skipif(os.environ.get('NO_SUMMING') == '1', reason='NO_SUMMING set to 1')
def test_sum():
    assert 2+2 == 4

@pytest.mark.xfail
def test_get_element_from_list():
    custom_list = ["test"]
    assert(custom_list[0] == "test")