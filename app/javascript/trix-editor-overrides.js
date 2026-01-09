// Prevent all file attachments
window.addEventListener("trix-file-accept", function (event) {
  event.preventDefault();
  alert("Attachments are not supported!");
});

// // Prevent attachments by rules (type and size)
// window.addEventListener("trix-file-accept", function (event) {
//   const acceptedFileTypes = ["image/jpeg", "image/png"];
//   const maxFileSize = 1 * Math.pow(1024, 2); // 1MB

//   const errors = [];

//   if (!acceptedFileTypes.includes(event.file.type))
//     errors.push("Unsupported file type!");
//   if (event.file.size > maxFileSize) errors.push("Attachment is too large!");

//   if (errors.length > 0) {
//     event.preventDefault();
//     alert("Errors:\n" + errors.map((e) => `• ${e}`).join("\n"));
//   }
// });

// // Prevent attachments on specific editor
// window.onload = function () {
//   let lessonContent = document.querySelector("trix-editor#lesson_content");

//   if (lessonContent)
//     lessonContent.addEventListener("trix-file-accept", function (event) {
//       event.preventDefault();
//       alert("Attachments are not supported!");
//     });
// };
