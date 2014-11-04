# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ts = 0
series = undefined
start = (new Date()).getTime()

loadData = ->
  # ts = (new Date()).getTime()
  $.getJSON "/points/latest.json?id=#{ts}", (data) ->
    if data.length == 0
      currentTime = (new Date()).getTime()
      if (currentTime - start) > 2000
        add start, Math.random() * 30
        start = currentTime
      return

    $.each data, (k, v) ->
      ts = v.id
      add v.created_ts, v.temperature

add = (x, y) ->
  console.log x, y
  # x = (new Date()).getTime() # current time
  # y = Math.random()
  series.addPoint [
    x
    y
  ], true, true
  return

$ ->
  Highcharts.setOptions
    global:
      useUTC: false

  $.getJSON "/points/latest.json", (data) ->
    generate = ->
      # generate an array of random data
      results = []

      $.each data, (k, v) ->
        ts = v.id
        time = v.created_ts
        results.push
          x: time
          y: v.temperature

      results

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
