var WlogUtil = (function(){   
    return {
        submit:(function(id,data,action){
            if(data != undefined ) {
                for( var field in data) {
                    alert(field);
                    document.getElementById(field).value = data[field];
                }
            }

            if( action != undefined ) {
                document.getElementById(id).action = action;
            }
            document.getElementById(id).submit();
        })
    }
})();
