var load = () => 
{
    if(localStorage.getItem("lastOp") == null)
    {
        localStorage.setItem("lastOp", "0");
    }
    else
    {
        localStorage.setItem("lastOp", Number(localStorage.getItem("lastOp")) + 1);
    }

    var newOp = (Number(localStorage.getItem("lastOp"))).toString(16);
    var timings = [7,6,4,8,3,3,5,5,3,2,2,2,4,4,6,6,3,5,4,8,4,4,6,6,2,4,2,7,4,4,7,7,6,6,4,8,3,3,5,5,4,2,2,2,4,4,6,6,2,5,4,8,4,4,6,6,2,4,2,7,4,4,7,7,6,6,4,8,3,3,5,5,3,2,2,2,3,4,6,6,3,5,4,8,4,4,6,6,2,4,2,7,4,4,7,7,6,6,4,8,3,3,5,5,4,2,2,2,5,4,6,6,2,5,4,8,4,4,6,6,2,4,2,7,4,4,7,7,2,6,2,6,3,3,3,3,2,2,2,2,4,4,4,4,3,6,4,6,4,4,4,4,2,5,2,5,5,5,5,5,2,6,2,6,3,3,3,3,2,2,2,2,4,4,4,4,2,5,4,5,4,4,4,4,2,4,2,4,4,4,4,4,2,6,2,8,3,3,5,5,2,2,2,2,4,4,6,6,3,5,4,8,4,4,6,6,2,4,2,7,4,4,7,7,2,6,2,8,3,3,5,5,2,2,2,2,4,4,6,6,2,5,4,8,4,4,6,6,2,4,2,7,4,4,7,7]

    var thisOpcode = [localStorage.getItem("t0"), localStorage.getItem("t1"), localStorage.getItem("t2"), localStorage.getItem("t3"), localStorage.getItem("t4"), localStorage.getItem("t5"), localStorage.getItem("t6")]
    localStorage.setItem("op_" + (parseInt(newOp, 16) - 1).toString(16), thisOpcode)

    if(parseInt(newOp, 16) < 16)
    {
        newOp = "0" + newOp;
    }

    if(newOp == "100")
    {
        console.log("done")
        var all = []
        for(let i = 0; i <= parseInt("FF", 16); i++)
        {
            var a = [{op: i, value: localStorage.getItem("op_" + i.toString(16))}];
            all.push(JSON.stringify(a));
        }
        window.location = window.URL.createObjectURL(new Blob(all, { type: 'application/javascript;charset=utf-8' }))
    }
    else
    {
        window.location = "visual6502/expert.html?graphics=f&steps=" + (timings[parseInt(newOp, 16)] * 2) + "&logmore=Execute,State,DPControl&a=0&d=" + newOp + "0000000000000000000000000000000000000000000000"
    }
} 