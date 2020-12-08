$(document).ready(() => {
    $(".container").hide();
})

let items = {}

window.addEventListener("message", (event) => {
    const data = event.data
    if (data.action == "show") {
        $(".container").fadeIn()
        $(".container-items").html("")
        setupItems(data.items, data.shopId)
    } else if (data.action == "close") {
        $(".container").fadeOut()
    } else if (data.action == "update") {
        $('[data-hash]').each(function() {
            if ($(this).data("hash") == data.item) {
                $(this).attr("data-stock", data.stock)
                $('[data-item]').each(function() {
                    if ($(this).data("item") == data.item) {
                        $(this).html(`${data.stock}`)
                    }
                })
            }
        })
    }
})


setupItems = (items, id) => {
    $.each(items, (index, item) => {
        $(".container-items").append(`
            <div class="items" data-id="${id}" data-name="${item.name}" data-price="${item.price}" data-stock="${item.stock}" data-hash="${item.hash}" data-description="${item.description}">
                <span class="tooltip">
                ${item.description}<br>
                    <span id="stock" data-item="${item.hash}">Stock: ${item.stock}</span>
                </span>
                <div id="item-price">
                    $ ${item.price}
                </div>
                <div id="item-image">
                    <img src="./images/${item.hash}.png">
                </div>

                <div id="item-name">
                    ${item.name}
                </div>
             </div>
        `)
    })

    $(".items").draggable({
        appendTo: 'body',
        helper: 'clone',
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        start: function(event, ui) {
            // $(".ui-draggable-dragging").css({"width": "60px"})
            $(".ui-draggable-dragging").css({"opacity": "0.5"})
            $(".ui-draggable-dragging").css({"border":"3px solid #A1A1A1A1"})
        },
        stop: function(e, ui) {
            $(".ui-draggable-dragging").css({"opacity": "1"})
            $(".ui-draggable-dragging").css({"border":"1px solid #A1A1A1A1"})
        }
    })

    $('.buy').droppable({
        drop: function(event, ui) {

            var itemName = ui.draggable.attr("data-name");
            var shopID = ui.draggable.attr("data-id");
            var itemAmount = Number($("#number").val());
            var itemPrice = ui.draggable.attr("data-price");
            var itemHash = ui.draggable.attr("data-hash");
            var itemStock = ui.draggable.attr("data-stock");
            if (itemAmount < 0) {
                itemAmount = 1
            } else if (itemAmount == 0) {
                itemAmount = 1
            } else if (itemAmount > itemStock) {
                $.post("http://shop/outofstock", JSON.stringify({
                    name: itemName,
                    message: "You cant buy that many"
                }))
            }
            $.post("http://shop/buyItem", JSON.stringify({
                shopid: shopID,
                name: itemName,
                amount: itemAmount,
                itemPrice: itemPrice,
                itemHash: itemHash,
            }))
            //ui.draggable.attr("data-stock", newStock)
            
            // $(['data-item'].each(() => {
            //     if ($(this).data("item") == itemHash) {
            //         $(this)
            //     }
            // }))

            $("#number").val(0)
            setupItems()
        }
    })
}