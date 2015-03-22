(function() {

  jQuery(function() {
    var associates, designations;
    $('#assignment_designation_id').attr('disabled', true);
    $('#assignment_associate_id').attr('disabled', true);
    designations = $('#assignment_designation_id').html();
    associates = $('#assignment_associate_id').html();
    $('#assignment_skill_id').change(function() {
      var associate_options, designation, designation_options, escaped_designation, escaped_skill, skill;
      skill = $('#assignment_skill_id :selected').text();
      escaped_skill = skill.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
      designation_options = $(designations).filter("optgroup[label='" + escaped_skill + "']").html();
      if (designation_options) {
        $('#assignment_designation_id').html(designation_options);
        $('#assignment_designation_id').attr('disabled', false);
        designation = $('#assignment_designation_id :selected').text();
        escaped_designation = designation.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
        associate_options = $(associates).filter("optgroup[label='" + escaped_skill + "|" + escaped_designation + "']").html();
        if (associate_options) {
          $('#assignment_associate_id').html(associate_options);
          return $('#assignment_associate_id').attr('disabled', false);
        } else {
          $('#assignment_associate_id').empty();
          return $('#assignment_associate_id').attr('disabled', true);
        }
      } else {
        $('#assignment_skill_id').empty();
        $('#assignment_designation_id').empty();
        $('#assignment_associate_id').empty();
        $('#assignment_designation_id').attr('disabled', true);
        return $('#assignment_associate_id').attr('disabled', true);
      }
    });
    return $('#assignment_designation_id').change(function() {
      var associate_options, designation, escaped_designation, escaped_skill, skill;
      skill = $('#assignment_skill_id :selected').text();
      escaped_skill = skill.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
      designation = $('#assignment_designation_id :selected').text();
      escaped_designation = designation.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
      associate_options = $(associates).filter("optgroup[label='" + escaped_skill + "|" + escaped_designation + "']").html();
      if (associate_options) {
        $('#assignment_associate_id').html(associate_options);
        return $('#assignment_associate_id').attr('disabled', false);
      } else {
        $('#assignment_skill_id').empty();
        $('#assignment_designation_id').empty();
        $('#assignment_associate_id').empty();
        $('#assignment_designation_id').attr('disabled', true);
        return $('#assignment_associate_id').attr('disabled', true);
      }
    });
  });

}).call(this);
