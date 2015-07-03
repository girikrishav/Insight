jQuery ->
  $('#invoice_line_invoicing_milestone_id').change ->
    $('#invoice_line_amount').val('')
    if $('#invoice_line_invoicing_milestone_id').val() != ''
      invoicing_milestone_id = $('#invoice_line_invoicing_milestone_id').val()
      url = '/admin/api/invoicing_milestones/uninvoiced_amount?invoicing_milestone_id=' + invoicing_milestone_id
      $.ajax  url,
        success: (data, status, xhr) ->
          $('#invoice_line_amount').val(data.amount)
        error: (xhr, status, err) ->
          console.log(err)
