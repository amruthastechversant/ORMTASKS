
    document.addEventListener('DOMContentLoaded', function () {
       
        var modal = new bootstrap.Modal(document.getElementById('estimateModal'), {
            keyboard: false
        });

        var modalElement = document.getElementById('selectedTaskIdDisplayModal');
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

   
    document.querySelectorAll('.working_hours').forEach(function(element) {
        element.addEventListener('click', function() {
            var taskId = this.getAttribute('data-task-id');
            
           // document.getElementById('selectedTaskIdDisplay').querySelector('#selectedTaskId').textContent = 'Task iD: ' + taskId;
            fetch('getWorkingHours.cfm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept':'application/json'
                },
                body: JSON.stringify({ taskId: taskId })
                

            })
            .then(response => response.json()) // Convert response to JSON
            .then(data => {
                if (data.success) {
                // console.log(data.logs);
                    
                     let logEntries = data.logs;

                     let logHtml = `<strong>Task ID:</strong> ${taskId} <br><strong>Working Hours Logs:</strong><br>`;
                    logEntries.forEach(log =>{
                            logHtml  +=  `<p><strong>Date:</strong>${log.date}</p>`;
                            logHtml +=  `<p><strong>comments:</strong>${log.comments}</p>`;
                            
                    })
                   
                    document.getElementById('selectedTaskIdDisplay').innerHTML=logHtml
    
                } 

                
                else {
                    document.getElementById('selectedTaskIdDisplay').innerHTML = `<p style="color: red;">${data.message}</p>`;
                }
            })
            .catch(error => {
                
                console.error(error);
                document.getElementById('selectedTaskIdDisplay').innerHTML = `<p style="color: black;">Failed to fetch logs.</p>`;
            });
        });
    });
    


    