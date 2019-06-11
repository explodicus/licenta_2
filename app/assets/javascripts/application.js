// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
// = require turbolinks
//= require jquery3
//= require popper
//= require bootstrap
//= require_tree .
//= require_self

function show_lesson_delete(id) {
    for (var element of document.getElementsByClassName('lesson_delete')) {
        element.style.display = 'none';
    }
    document.getElementById(id).style.display = 'inline-block';
}

$(document).ready(function() {
    if (locale == 'ro') {
        var lang = {
            "sProcessing": "Procesează...",
            "sLengthMenu": "Afișează _MENU_ înregistrări pe pagină",
            "sZeroRecords": "Nu am găsit nimic - ne pare rău",
            "sInfo": "Afișate de la _START_ la _END_ din _TOTAL_ înregistrări",
            "sInfoEmpty": "Afișate de la 0 la 0 din 0 înregistrări",
            "sInfoFiltered": "(filtrate dintr-un total de _MAX_ înregistrări)",
            "sInfoPostFix": "",
            "sSearch": "Caută:",
            "sUrl": "",
            "oPaginate": {
                "sFirst": "Prima",
                "sPrevious": "Precedenta",
                "sNext": "Următoarea",
                "sLast": "Ultima"
            }
        }
    }
    else {
        if (locale == 'ru') {
            var lang = {
                "processing": "Подождите...",
                "search": "Поиск:",
                "lengthMenu": "Показать _MENU_ записей",
                "info": "Записи с _START_ до _END_ из _TOTAL_ записей",
                "infoEmpty": "Записи с 0 до 0 из 0 записей",
                "infoFiltered": "(отфильтровано из _MAX_ записей)",
                "infoPostFix": "",
                "loadingRecords": "Загрузка записей...",
                "zeroRecords": "Записи отсутствуют.",
                "emptyTable": "В таблице отсутствуют данные",
                "paginate": {
                    "first": "Первая",
                    "previous": "Предыдущая",
                    "next": "Следующая",
                    "last": "Последняя"
                },
                "aria": {
                    "sortAscending": ": активировать для сортировки столбца по возрастанию",
                    "sortDescending": ": активировать для сортировки столбца по убыванию"
                }
            }
        }
    }

    $('#datatable').DataTable( {
        "language": lang
    } );
} );