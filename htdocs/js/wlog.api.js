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
        }),
        amazon_lookup:(function(id,asin){

           jQuery.getJSON(
            '/api/amazon/item/' + asin + '/',
            {},
            function(json){
               if(json.status){
                    $('#' + id ).html('<a href="' +  json.item.url + '"><img src="' + json.item.image + '" border="0" /></a><p><a href="' +  json.item.url + '">' + json.item.title + '</a></p>');
               }
            }
           );
             
        })
    }
})();
