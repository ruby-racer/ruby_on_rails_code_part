$ ->
  $('#unsubscribe_email, #order_id').on 'change keyup', ->
    if $('#unsubscribe_email').val().length > 0
      $('#order_id').removeAttr 'required'
    if $('#order_id').val().length > 0
      $('#unsubscribe_email').removeAttr 'required'
    # destroy ParsleyForm instance
    $('#new_unsubscribe').parsley().destroy()
    # bind parsley
    $('#new_unsubscribe').parsley()
    return
  $('#account-select li').click ->
    account_id = $(@).data('account-id')
    $('#unsubscribe_account_id').val account_id
    $('#account-select li').removeClass 'active'
    $(this).addClass 'active'
    return
  $('button#unsubscribe-submit').click ->
    if $('form#new_unsubscribe').parsley().validate()
      NProgress.start()
      $('form#new_unsubscribe').submit()
    return
  return
