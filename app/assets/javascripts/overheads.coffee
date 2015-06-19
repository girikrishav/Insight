jQuery ->
  $('#overhead_periodicity_id').change ->
    from_date = $('#overhead_from_date').val()
    periodicity = $('#overhead_periodicity_id').val()
    url = '/admin/api/overheads/mytest?from_date=' + from_date + '&periodicity=' + periodicity
    $.ajax  url,
      success: (data, status, xhr) ->
        $('#overhead_to_date').val(data.to_date)
      error: (xhr, status, err) ->
        console.log(err)
