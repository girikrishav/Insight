jQuery ->
  $('#invoice_adder_invoice_adder_type_id').change ->
    if $('#invoice_adder_invoice_adder_type_id').val() != ''
      invoice_header_id = $('#invoice_adder_invoice_header_id').val()
      invoice_adder_type_id = $('#invoice_adder_invoice_adder_type_id').val()
      url = '/admin/api/invoice_adders/adder_amount?invoice_header_id=' + invoice_header_id + '&invoice_adder_type_id=' + invoice_adder_type_id
      $.ajax  url,
        success: (data, status, xhr) ->
          $('#invoice_adder_amount').val(data.amount)
        error: (xhr, status, err) ->
          console.log(err)
      $('#invoice_adder_amount').attr('readonly', true)
    else
      $('#invoice_adder_amount').val('' )
      $('#invoice_adder_amount').attr('readonly', false)