jQuery ->
  $('#invoice_adder_invoice_adder_type_id').change ->
    if $('#invoice_adder_invoice_adder_type_id').val() != ''
      $('#invoice_adder_amount').attr('disabled', true)
    else
      $('#invoice_adder_amount').attr('disabled', false)