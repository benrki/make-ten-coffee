{ StyleSheet } = require 'react-native'

module.exports = StyleSheet.create
  container:
    flex: 1
    justifyContent: 'center'
    backgroundColor: '#F5FCFF'
    alignItems: 'center'
  titleContainer:
    flexDirection: 'row'
    marginBottom: 50
  title:
    fontSize: 30
    textAlign: 'center'
    margin: 10
    fontWeight: 'bold'
    alignSelf: 'auto'
  game:
    marginBottom: 100
    flexDirection: 'row'
  picker:
    height: 50
    width: 25
    justifyContent: 'center'
    margin: 10
  number:
    height: 50
    width: 25
    fontSize: 25
    textAlign: 'center'
    margin: 10
  details:
    justifyContent: 'center'
    alignItems: 'center'

