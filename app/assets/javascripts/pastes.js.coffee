# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@pastejs =
  index: ->
    file = $('#main form input[type="file"]').parent()
    text = $('#main form textarea').parent()
    form_toggle = $('<a />',
      id: 'formtoggle'
      href: '#'
      click: ->
        $this = $(this)
        unless $this.data('state') == 2
          formToggle 2
          $this.data 'state', 2
        else
          formToggle 1
          $this.data 'state', 1
        $('.errorlist').hide()
        false
    ).appendTo "#main"

    formToggle = (st) ->
      switch st
        when 1
          file.hide().children('input').val '' # perhaps we must not hide textarea, but set it inactive.
          text.fadeIn()
          form_toggle.text file.children('label').text().slice(0,-1)
        when 2
          text.hide().children('textarea').val('').text ''
          file.fadeIn()
          form_toggle.text text.children('label').text().slice(0,-1)
        when 0
          text.show()
          file.show()
          form_toggle.hide()

    formToggle if $("#main .errorlist").length
        text_disp = text.next("ul.errorlist").length ? 1 : 0
        file_disp = file.next("ul.errorlist").length ? 1 : 0
        if text_disp && file_disp
          0
        else if text_disp
          1
        else if file_disp
          2
        else
          0
      else
        1

  show: ->
    getPostInfo = ->
      url = "#{window.location.pathname}.json"
      $.getJSON url, {status:true}, (data) ->
        return window.setTimeout(getPostInfo, 3000) unless data['processed']
        return {} unless data['success']
        
        id = data['id']
        $.getJSON(url, {links:true}, (ldata) ->
          return unless id == ldata['id']

          links =
            mxml: ldata['mxml']
            ly:   ldata['lilypond']
            pdf:  ldata['pdf']
        
          $("#paste-links ul").empty().html(
            for k, v of links
              "<li><a href=\"#{v}\">#{ k.toUpperCase() }</a></li>" if v
          )

          $("#paste-body").empty().html(
            for i in ldata['images']
              "<img src=\"#{i}\" class=\"paste-preview\" />"
          )

        ).error (j, st, err) ->
          alert "can't get status data"
    getPostInfo()