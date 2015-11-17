function toggleUsers(filter, table_type) {
  var section = document.getElementById(table_type);
  var table = section.children[0];
  for (var i = 1; i < table.rows.length; i++) {
    var row = table.rows[i];
    if (row.classList.contains(filter)) {
      $(row).show();
    } else {
      $(row).hide();
    }
  }
  return false;
}

function showAllUsers(table_type) {
  var section = document.getElementById(table_type);
  var table = section.children[0];
  for (var i = 1; i < table.rows.length; i++) {
    var row = table.rows[i];
    $(row).show();
  }
  return false;
}
