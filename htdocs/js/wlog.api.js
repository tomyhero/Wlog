var WlogAPI = (function(){   
    return {
        done_preview:(function(body){
            $('#body-form-container').toggle();
            $('#preview-container').toggle();
        }),
        preview:(function(body){
           jQuery.getJSON(
            '/cms/api/preview',
            {
                body : $('#body').val()
            },
            function(json){
               if(json.status){
                    var link = '<p><a href="javascript:WlogAPI.done_preview()">Back</a><p>';
                    $('#preview-container').html( link + json.article );
                    $('#body-form-container').toggle();
                    $('#preview-container').toggle();
               }
            }
           );
        })
    }
})();
