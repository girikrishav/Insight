jQuery ->
  $('#assignment_designation_id').attr('disabled', true)
  $('#assignment_associate_id').attr('disabled', true)
  designations = $('#assignment_designation_id').html()
  associates = $('#assignment_associate_id').html()
  $('#assignment_skill_id').change ->
    skill = $('#assignment_skill_id :selected').text()
    escaped_skill = skill.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    designation_options = $(designations).filter("optgroup[label='#{escaped_skill}']").html()
    if designation_options
      $('#assignment_designation_id').html(designation_options)
      $('#assignment_designation_id').attr('disabled', false)
      designation = $('#assignment_designation_id :selected').text()
      escaped_designation = designation.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      associate_options = $(associates).filter("optgroup[label='#{escaped_skill}|#{escaped_designation}']").html()
      if associate_options
        $('#assignment_associate_id').html(associate_options)
        $('#assignment_associate_id').attr('disabled', false)
      else
        $('#assignment_associate_id').attr('disabled', true)
    else
      $('#assignment_designation_id').val([])
      $('#assignment_designation_id').attr('disabled', true)
      $('#assignment_associate_id').val([])
      $('#assignment_associate_id').attr('disabled', true)
  $('#assignment_designation_id').change ->
    skill = $('#assignment_skill_id :selected').text()
    escaped_skill = skill.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    designation = $('#assignment_designation_id :selected').text()
    escaped_designation = designation.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    associate_options = $(associates).filter("optgroup[label='#{escaped_skill}|#{escaped_designation}']").html()
    if associate_options
      $('#assignment_associate_id').html(associate_options)
      $('#assignment_associate_id').attr('disabled', false)
    else
      $('#assignment_designation_id').val([])
      $('#assignment_designation_id').attr('disabled', true)
      $('#assignment_associate_id').val([])
      $('#assignment_associate_id').attr('disabled', true)


#ORIGINAL
#jQuery ->
#  $('#assignment_designation_id').attr('disabled', true)
#  $('#assignment_associate_id').attr('disabled', true)
#  designations = $('#assignment_designation_id').html()
#  associates = $('#assignment_associate_id').html()
#  $('#assignment_skill_id').change ->
#    skill = $('#assignment_skill_id :selected').text()
#    escaped_skill = skill.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
#    designation_options = $(designations).filter("optgroup[label='#{escaped_skill}']").html()
#    if designation_options
#      $('#assignment_designation_id').html(designation_options)
#      $('#assignment_designation_id').attr('disabled', false)
#      designation = $('#assignment_designation_id :selected').text()
#      escaped_designation = designation.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
#      associate_options = $(associates).filter("optgroup[label='#{escaped_skill}|#{escaped_designation}']").html()
#      if associate_options
#        $('#assignment_associate_id').html(associate_options)
#        $('#assignment_associate_id').attr('disabled', false)
#      else
#        $('#assignment_associate_id').attr('disabled', true)
#    else
#      $('#assignment_designation_id').val([])
#      $('#assignment_designation_id').attr('disabled', true)
#      $('#assignment_associate_id').val([])
#      $('#assignment_associate_id').attr('disabled', true)
#  $('#assignment_designation_id').change ->
#    skill = $('#assignment_skill_id :selected').text()
#    escaped_skill = skill.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
#    designation = $('#assignment_designation_id :selected').text()
#    escaped_designation = designation.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
#    associate_options = $(associates).filter("optgroup[label='#{escaped_skill}|#{escaped_designation}']").html()
#    if associate_options
#      $('#assignment_associate_id').html(associate_options)
#      $('#assignment_associate_id').attr('disabled', false)
#    else
#      $('#assignment_designation_id').val([])
#      $('#assignment_designation_id').attr('disabled', true)
#      $('#assignment_associate_id').val([])
#      $('#assignment_associate_id').attr('disabled', true)