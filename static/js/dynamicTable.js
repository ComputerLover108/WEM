    function clone() {
        var tbl = document.getElementById("dynamicTable").tBodies[0];
        if (tbl.rows.length > 1) {
            var pos = tbl.rows.length - 1
            var newNode = tbl.rows[pos].cloneNode(true);
            tbl.appendChild(newNode);
        }
    }

    function alldell() {
        var des = document.getElementsByName('checkItem');
        // console.log(des)
        var alldell = document.getElementById('delall')
        if (delall.checked) {
            for (var i = 0; i < des.length; i++) {
                des[i].checked = true
            }
        }
        alldell.checked = false
    }

    function del() {
        var c = document.getElementsByName('checkItem');
        var dynamicTable = document.getElementById('dynamicTable');
        var rowCount = dynamicTable.rows.length;
        for (var i = 0; i < c.length; i++) {
            console.log("删除", i, "行,表格一共有", rowCount, "行。");
            if (c[i].checked) {
                dynamicTable.deleteRow(i);
            }

        }

    }

    function dataAcquisition() {
        var dynamicTable = document.getElementById('dynamicTable');
        var data = new Array();
        for (var i = 1; i < dynamicTable.rows.length; i++) {
            var record = {}
            for (var j = 1; j < dynamicTable.rows[i].cells.length; j++) {
                var x = dynamicTable.rows[i].cells[j].firstChild
                console.log(x.nodeName,x.name)
                switch (x.nodeName) {
                    case "INPUT":
                        record[x.name] = x.value;
                        break;
                    case "SELECT":
                        record[x.name] = x.options[x.selectedIndex].value;
                        break;
                    default:
                        record[x.name] = "";
                }
            }
            data.push(record);
        }
        // console.log(data);
        return data
    }
