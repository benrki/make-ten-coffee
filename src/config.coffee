module.exports =
  NUMLENGTH: 4 # Default amount of numbers in a game
  OPERATORS: ['*', '/', '+', '-']
  OPMAP:
    '*': (n1, n2) -> n1 * n2
    '/': (n1, n2) -> n1 / n2
    '+': (n1, n2) -> n1 + n2
    '-': (n1, n2) -> n1 - n2

