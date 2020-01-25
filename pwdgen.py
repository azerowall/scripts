import itertools
import math

class PositionalPasswordGen:
    '''
        Password generator with calculatable password list length
        Just product()
    '''
    def __init__(self, template):
        self.tpl = template

    def gen(self):
        for t in itertools.product(*self.tpl):
            yield t

    def __iter__(self):
        return (''.join(x) for x in self.gen())

    def __len__(self):
        result = 1
        for r in self.tpl:
            result *= len(r)
        return result

class PasswordGen(PositionalPasswordGen):
    '''
        Like the same above but with permutations()
    '''
    def __init__(self, template):
        self.tpl = template

    def gen(self):
        for p in super().gen():
            for r in itertools.permutations(p, len(p)):
                yield r

    def __len__(self):
        return super().__len__() * math.factorial(len(tpl))



class permutations:
    def __init__(self, iterable, r=None):
        self.iterable = iterable
        self.r = r if r is not None else len(iterable)

    def __len__(self):
        n = math.factorial(len(self.iterable))
        d = math.factorial(len(self.iterable) - self.r)
        return n // d

    def __iter__(self):
        return (''.join(x) for x in itertools.permutations(self.iterable, self.r))


if __name__ == '__main__':
    # Example:
    tpl = [
        ['john', 'johnnie'],
        ['01-01-1991', '01011991', '010191'],

        # i know you don't want to write something like this every time
        # [''.join(x) for x in itertools.permutations(['_', '@'])]
        # so...
        permutations(['_', '@'])
    ]
    passwords = PasswordGen(tpl)
    print('Total: ', len(passwords))
    for i, p in enumerate(passwords):
        print(i, p)