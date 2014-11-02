# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ts = 0
series = undefined

loadData = ->
  $.getJSON "/points/latest.json?last_update_ts=#{ts}", (data) ->
    $.each data, (k, v) ->
      ts = v.created_ts
      add v.created_ts, v.temperature

add = (x, y) ->
  console.log x, y
  x = (new Date()).getTime() # current time
  # y = Math.random()
  series.addPoint [
    x
    y
  ], true, true
  return

generate = ->

  # generate an array of random data
  data = []
  time = (new Date()).getTime()
  i = undefined
  i = -19
  while i <= 0
    data.push
      x: time + i * 1000
      y: Math.random() * 30

    i += 1
  data

# 2.
$ ->
  $(document).ready ->
    Highcharts.setOptions
      global:
        useUTC: false

    $("#container").highcharts
      chart:
        type: "spline"
        animation: Highcharts.svg # don't animate in old IE
        marginRight: 10
        events:
          load: ->

            # set up the updating of the chart each second
            series = @series[0]
            setInterval loadData, 1000
            # loadData()
            return

      title:
        text: "Live random data"

      xAxis:
        type: "datetime"
        tickPixelInterval: 150

      yAxis:
        title:
          text: "Value"

        plotLines: [
          value: 0
          width: 1
          color: "#808080"
        ]

      tooltip:
        formatter: ->
          "<b>" + @series.name + "</b><br/>" + Highcharts.dateFormat("%Y-%m-%d %H:%M:%S", @x) + "<br/>" + Highcharts.numberFormat(@y, 2)

      legend:
        enabled: false

      exporting:
        enabled: false

      series: [
        name: "Random data"
        data: generate()
      ]

    return

  return
