$(function() {
    window.addEventListener(
        'message',
        function(event) {
            if (event.data.action == 'updateJob') {
                $('#praca').html(event.data.praca);
            }
            if (event.data.action == 'updateJob2') {
                $('#praca2').html(event.data.praca2);
            }
            if (event.data.action == 'updateJob3') {
                $('#praca3').html(event.data.praca3);
            }

            switch (event.data.action) {
                case 'toggle':
                    if (event.data.state == true) {
                        $("#wrap").css('display', 'block');
                    } else {
                        $('#wrap').css('display', 'none');
                    }
                    break;

                case 'updateId':
                    $('#server_uptime').html(event.data.id);
                    break;

                case 'close':
                    $('#wrap').css('display', 'none');
                    break;
                case 'updatePlayerJobs':
                    var jobs = event.data.jobs;

                    $('#player_count').html(jobs.player_count);

                    if (jobs.ems > 0) {
                        $('#ems').html(
                            '<span style="color: green">' + jobs.ems + '</span>'
                        );
                    } else {
                        $('#ems').html('<span style="color: red">0</span>');
                    }

                    if (jobs.doj > 0) {
                        $('#doj').html(
                            '<span style="color: green">' + jobs.doj + '</span>'
                        );
                    } else {
                        $('#doj').html('<span style="color: red">0</span>');
                    }


                    if (jobs.sapd > 0) {
                        $('#sapd').html('<span style="color: green">' + jobs.sapd + '</span>');
                    } else {
                        $('#sapd').html('<span style="color: red">0</span>');
                    }

                    if (jobs.police > 0) {
                        $('#police').html('<span style="color: green">' + jobs.police + '</span>');
                    } else {
                        $('#police').html('<span style="color: red">0</span>');
                    }

                    if (jobs.mechanik > 0) {
                        $('#mechanik').html(
                            '<span style="color: green">' + jobs.mechanik + '</span>'
                        );
                    } else {
                        $('#mechanik').html('<span style="color: red">0</span>');
                    }

                    break;
                default:
                    break;
            }
        },
        false
    );
});