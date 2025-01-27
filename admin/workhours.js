
    document.addEventListener('DOMContentLoaded', function () {
       
        var modal = new bootstrap.Modal(document.getElementById('estimateModal'), {
            keyboard: false
        });

     
        var modalElement = document.getElementById('estimateModal');
        modalElement.addEventListener('show.bs.modal', function (event) {
        
            var button = event.relatedTarget; 
            var taskId = button.getAttribute('data-task-id'); 
            var userId = button.getAttribute('data-user-id');
           
            document.getElementById('modalTaskId').value = taskId;
            document.getElementById('modalUserId').value = userId;
        });
    });



    setTimeout(function () {
        const successMessage = document.getElementById('successMessage');
        if (successMessage) {
            successMessage.style.display = 'none';
        }
    }, 3000); // 5000ms = 5 seconds
