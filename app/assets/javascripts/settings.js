function avatarPreview() {
    var upload = document.getElementById("avatar-upload");
    var preview = document.getElementById("avatar-upload-preview");
    var oFReader = new FileReader();
    oFReader.readAsDataURL(upload.files[0]);

    oFReader.onload = function (oFREvent) {
        preview.src = oFREvent.target.result;
    };
};
