async = require 'async'
http = require 'http'
fs = require 'fs'

getResult = (delay, callback = ->) ->

  if delay is 'fail'
    error = new Error 'Mega FAIL!!!'
    callback error
    return

  url = "http://localhost:3000/delay/#{delay}"
  http.get url, (response) ->
    response.on 'data', (data) ->
      callback null, data.toString()


displayResult = (delay, callback = ->) ->
  getResult delay, (error, data) ->
    console.log 'result:', data
    callback error, delay




###
getResult 1000, (error, result) ->
  console.log 'result:', result

displayResult 1000
###



###
async.each [5000, 1000, 3000, 2000, 4000], displayResult, (error) ->
  throw error if error?
  console.log 'DONE'

async.eachSeries [5000, 1000, 3000, 2000, 4000], displayResult, (error) ->
  throw error if error?
  console.log 'DONE'

async.eachLimit [5000, 1000, 3000, 2000, 4000], 2, displayResult, (error) ->
  throw error if error?
  console.log 'DONE'
###



###
async.map [5000, 1000, 3000, 2000, 4000], getResult, (error, result) ->
  throw error if error?
  console.log 'DONE', result

async.sortBy [5000, 1000, 3000, 2000, 4000], getResult, (error, result) ->
  throw error if error?
  console.log 'DONE', result



getArray = (length, callback) ->
  getResult length*1000, ->
    callback null, [0...length]

async.concat [5, 1, 3, 2, 4], getArray, (error, result) ->
  console.log 'DONE', result
###


###
files_list = []
fs.readdir '../../content/folder1', (error, result) ->
  throw error if error?
  files_list = files_list.concat result

  fs.readdir '../../content/folder2', (error, result) ->
    files_list = files_list.concat result

    fs.readdir '../../content/folder3', (error, result) ->
      files_list = files_list.concat result

      console.log 'DONE', files_list


folders = [
  '../../content/folder1'
  '../../content/folder2'
  '../../content/folder3'
]

async.concat folders, fs.readdir, (error, result) ->
  throw error if error?
  console.log 'DONE', result
###





###

isSlowEnough = (delay, callback) ->
  getResult delay, (error, result) ->
    callback (parseInt result) > 2500



# no error

async.filter [5000, 1000, 3000, 2000, 4000], isSlowEnough, (result) ->
  console.log 'DONE', result

async.detect [5000, 1000, 3000, 2000, 4000], isSlowEnough, (result) ->
  console.log 'DONE', result

async.some [5000, 1000, 3000, 2000, 4000], isSlowEnough, (result) ->
  console.log 'DONE', result

async.some [1000, 2000], isSlowEnough, (result) ->
  console.log 'DONE', result

async.every [5000, 1000, 3000, 2000, 4000], isSlowEnough, (result) ->
  console.log 'DONE', result

async.every [5000, 4000], isSlowEnough, (result) ->
  console.log 'DONE', result
###




###
getFilesList = (callback) ->
  fs.readdir '../../content/folder1', callback

loadAjaxData = (callback) ->
  getResult 3000, callback

async.series [getFilesList, loadAjaxData], (error, result) ->
  throw error if error?
  console.log 'DONE', result

async.series {files: getFilesList, data: loadAjaxData}, (error, result) ->
  throw error if error?
  console.log 'DONE', result
###



###
tasks =
  fast:   (callback) -> getResult 1000, callback
  medium: (callback) -> getResult 3000, callback
  slow:   (callback) -> getResult 5000, callback

async.series tasks, (error, result) ->
  throw error if error?
  console.log 'DONE', result

async.parallel tasks, (error, result) ->
  throw error if error?
  console.log 'DONE', result

async.parallelLimit tasks, 2, (error, result) ->
  throw error if error?
  console.log 'DONE', result
###





###
displayRandomResult = (callback) ->
  delay = (Math.ceil Math.random() * 3) * 1000
  displayResult delay, callback

async.forever displayRandomResult, (error) ->
  throw error
###




###
async.waterfall [

  (callback) ->
    console.log 'Prvy task'
    callback null, 'raz', 'dva'

  (arg1, arg2, callback) ->
    console.log 'Druhy task'
    console.log '1. argument:', arg1
    console.log '2. argument:', arg2
    callback null, 'tri'

  (arg, callback) ->
    console.log 'Treti task'
    console.log '1. argument:', arg
    callback null, 'hotovo'

], (error, result) ->
  throw error if error?
  console.log 'Vysledok:', result
###





###
fn1 = (delay, callback) ->
  getResult delay, callback

fn2 = (result, callback) ->
  getResult result * 2, callback

myFunction = async.compose fn1, fn2

myFunction 2000, (error, result) ->
  throw error if error?
  console.log 'DONE', result
###





###
# https://github.com/caolan/async#queueworker-concurrency

my_queue = async.queue displayResult, 2

my_queue.drain = ->
  console.log 'DONE'

my_queue.push 1000
my_queue.push 2000

setTimeout (
  ->
    my_queue.push 2000
    my_queue.push 1000
), 3000
###




###

fn1 = (callback) -> displayResult 1000, callback
fn2 = (callback) -> displayResult 2000, callback
fn3 = (callback) -> displayResult 3000, callback
fn4 = (callback) -> displayResult 4000, callback

tasks =
  first:  fn1
  second: fn2
  third:  fn3
  fourth: fn4
  # first:  ['second', fn1]
  # second: fn2
  # third:  ['first', 'fourth', fn3]
  # fourth: fn4

async.auto tasks, (error, result) ->
  throw error if error?
  console.log 'DONE', result
###
