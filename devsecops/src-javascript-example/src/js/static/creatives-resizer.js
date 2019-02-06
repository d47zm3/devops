/* eslint-disable */
// Third party script
function resize_adunit(e, t) {
  var payload = {
    meta: {
      type: 'resize_adunit',
      href: window.location.href,
      name: window.name,
      frameId: window.frameElement ? window.frameElement.id : null
    },
    data: {
      width: e,
      height: t,
    },
  };

  window.parent.postMessage(JSON.stringify(payload), "*");
}

addEventListener("load", function () {
  window.setTimeout(function () {
    var e = document.body.clientWidth || 0;
    if (0 === document.body.offsetHeight || document.body.offsetHeight < 20)
      resize_adunit("0px", "0px");
    else if (0 !== e) {
      var t = document.body.offsetHeight;
      resize_adunit(e + "px", t + "px");
    }
    var n = document.getElementsByTagName("img");
    for (i = 0; i < n.length; i++)
      n[i] &&
      n[i].clientHeight > 20 &&
      resize_adunit(e + "px", n[i].clientHeight + "px");
  }, 1500);
});
