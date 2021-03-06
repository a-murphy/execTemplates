Function task() {
  <% _.each(obj.script, function(cmd) { %>
    exec_cmd '<%= cmd %>'
  <% }) %>
}
<% if (obj.onSuccess) { %>
Function on_success() {
  <% _.each(obj.onSuccess.script, function(cmd) { %>
    Invoke-Expression '<%= cmd %>'
  <% }); %>
}
<% } %>

<% if (obj.onFailure) { %>
Function on_failure() {
  <% _.each(obj.onFailure.script, function(cmd) { %>
    Invoke-Expression '<%= cmd %>'
  <% }); %>
}
<% } %>

<% if (obj.always) { %>
Function always() {
  <% _.each(obj.always.script, function(cmd) { %>
    Invoke-Expression '<%= cmd %>'
  <% }); %>
}
<% } %>

Function before_exit() {
  if ($global:is_success) {
    <% if (obj.onSuccess && !_.isEmpty(obj.onSuccess.script)) { %>
      exec_cmd "on_success"
    <% } %>

    <% if (obj.always && !_.isEmpty(obj.always.script)) { %>
      exec_cmd "always"
    <% } %>

    Write-Output "__SH__SCRIPT_END_SUCCESS__";
  } else {
    <% if (obj.onFailure && !_.isEmpty(obj.onFailure.script)) { %>
      exec_cmd "on_failure"
    <% } %>

    <% if (obj.always && !_.isEmpty(obj.always.script)) { %>
      exec_cmd "always"
    <% } %>

    Write-Output "__SH__SCRIPT_END_FAILURE__";
  }
}

Function main() {
  $global:is_success = $TRUE
  Try
  {
    exec_grp "task" "Executing Task $env:TASK_NAME"
  }
  Catch
  {
    $global:is_success = $FALSE
  }
  Finally
  {
    before_exit
  }
}

main
