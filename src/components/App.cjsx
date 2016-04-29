React = {
  Animated,
  Component,
  Text,
  TextInput,
  View,
  Picker,
  TouchableHighlight
} = require 'react-native'
styles = require '../styles/app'

NUMLENGTH = 4 # Default amount of numbers in a game
OPERATORS = ['*', '/', '+', '-']
OPMAP =
  '*': (n1, n2) -> n1 * n2
  '/': (n1, n2) -> n1 / n2
  '+': (n1, n2) -> n1 + n2
  '-': (n1, n2) -> n1 - n2

getRandomInt = (min, max) ->
  return Math.floor(Math.random() * (max - min)) + min

curry = (f) ->
  parameters = Array.prototype.slice.call(arguments, 1)
  -> f.apply this, parameters.concat(Array.prototype.slice.call(arguments, 0))

generateRandArray = ({ size, min, max }) ->
  res = []
  res.push(getRandomInt(min, max)) for i in [0...size]
  res

class App extends Component
  animateTitle: ->
    Animated.timing(@state.title.opacity, {
      toValue: 1,
      duration: 3000
    }).start()
    Animated.timing(@state.number.opacity, {
      toValue: 1,
      duration: 5000
    }).start()

  componentDidMount: ->
    @animateTitle()

  getRandomOperators: (n) ->
    return generateRandArray({ size: n, min: 0, max: 4 }).map(
      (n) => OPERATORS[n]
    )

  doOperation: ({ operators, numbers }, index) ->
    # Avoid mutating inputs
    numbers   = numbers.slice(0)
    operators = operators.slice(0)
    n1    = numbers[index]
    n2    = numbers[index + 1]
    op    = operators.splice(index, 1)[0]

    numbers[index] = OPMAP[op](n1, n2)
    numbers.splice(index + 1, 1)

    { numbers, operators }

  evaluateCombination: ({ numbers, operators }) ->
    doOperation = curry(@doOperation, { operators, numbers })

    if numbers.length is 1
      # Base case
      numbers[0]
    else
      multOrDiv = operators.findIndex((op) -> op is '*' or op is '/')
      index = if multOrDiv isnt -1 then multOrDiv else 0

      @evaluateCombination.bind(@)(doOperation(index))

  generateNumbers: (n) ->
    generateRandArray({ size: n, min: 1, max: 10 })

  generateNewGame: (numLength = NUMLENGTH) ->
    numbers   = @generateNumbers(numLength)
    operators = @getRandomOperators(numLength - 1)
    value     = @evaluateCombination({ numbers, operators })
    date      = new Date().getTime()

    if Math.floor(value) isnt value
      @generateNewGame.bind(@)(numLength)
    else
      console.info('generateNewGame', operators)
      {
        title:
          opacity: new Animated.Value(0)
        number:
          value: value
          opacity: new Animated.Value(0)
        numbers
        operators: ['*', '*', '*']
        text: null
        win:
          key: "win-#{date}"
          text:
            key: "win-text-#{date}"
            opacity: new Animated.Value(0)
          reset:
            key: "win-reset-#{date}"
            opacity: new Animated.Value(0)
      }

  constructor: (props) ->
    super(props)
    @state = @generateNewGame()

  animateWin: ->
    Animated.timing(@state.win.text.opacity, {
      toValue: 1,
      duration: 1000
    }).start()
    Animated.timing(@state.win.reset.opacity, {
      toValue: 1,
      duration: 2000
    }).start()

  # Set the current state operator at index i
  setOperator: (i, op) ->
    operators = @state.operators
    operators[i] = op

    @setState({ operators })
    value = @evaluateCombination(@state)
    if value is @state.number.value
      @state.text = null
      @animateWin()
    else
      @state.text = value
    @forceUpdate()

  renderInputs: ({ numbers, operators }) ->
    inputs = []
    setOperator = @setOperator.bind(@)

    numbers.forEach (n, i) ->
      isLastElement = i >= (numbers.length - 1)

      inputs.push(
        <Text key={"numbers-#{i}"} style={styles.number}>
          {n.toString()}
        </Text>
      )

      unless isLastElement
        inputs.push(
          <Picker
            key={"input-#{i}"}
            style={styles.picker}
            selectedValue={operators[i]}
            onValueChange={curry(setOperator, i)}
          >
            {OPERATORS.map((op) =>
              <Picker.Item
                style={styles.input}
                key={"input-#{i}-#{op}"}
                label={op}
                value={op}
              />
            )}
          </Picker>
        )

    inputs

  reset: ->
    @setState(@generateNewGame.bind(@)())
    @animateTitle()

  render: ->
    # Necessary since React gives our function a parameter we don't want
    reset = @reset.bind(@)

    (
      <View style={styles.container}>
        <View style={styles.titleContainer}>
          <Animated.Text
            style={[{ opacity: @state.title.opacity }, styles.title]}
          >
            Make
          </Animated.Text>
          <Animated.Text
            style={[{ opacity: @state.number.opacity }, styles.title]}
          >
            {@state.number.value}
          </Animated.Text>
        </View>
        <View style={styles.game}>
          {@renderInputs(@state)}
        </View>
        <View style={styles.details}>
          <Text
            style={ { opacity: if @state.text? then 1 else 0 } }
          >
            {@state.text}
          </Text>
          <Animated.Text
            key={@state.win.text.key}
            style={[{ opacity: @state.win.text.opacity }, styles.win]}
          >
            A winner is you!
          </Animated.Text>
          <TouchableHighlight
            key={@state.win.key}
            onPress={reset}
          >
            <Animated.Text
              key={@state.win.reset.key}
              style={[{ opacity: @state.win.reset.opacity }, styles.win]}
            >
              Tap to play again
            </Animated.Text>
          </TouchableHighlight>
        </View>
      </View>
    )

module.exports = App
