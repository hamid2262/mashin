jQuery ->
  # $('#image_name').attr('name','image[name]')
  $('#new_image').fileupload
    dataType: 'script'
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i
      file = data.files[0]
      if file.size > 5000000
         alert(" حجم فیل بیش از پنج مگابایت است. ")
      else if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('#new_image').append(data.context)
        # $('.actions input[type="submit"]').click (e) ->
        data.submit()
          # e.preventDefault()           
      else
        alert("#{file.name} نیست gif یا jpg ،png فایل تصویری با فرمتهای ")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        data.context.find('.bar').css('width', progress + '%')
    done: (e, data) ->
      $('.actions input[type="submit"]').off('click')
      $('.upload').remove()
        