export default function s3DirectUpload(options) {
  const {signing, s3} = options;

  return function(file) {

    return file
      ? signFile(file).then((data) => uploadFile(file, data))
      : Promise.resolve('');
  }

  function signFile(file) {
    let query = `objectName=${scrubFileName(file.name)}&contentType=${encodeURIComponent(file.type)}`
    if(s3.path) {
      query += `&path=${encodeURIComponent(s3.path)}`;
    }

    return fetch(`${signing.url}?${query}`)
    .then(res => res.json());
  }

  function uploadFile(file, signedParams) {
    return fetch(signedParams.signedUrl, {
      method: 'PUT',
      headers: {
        'Content-Type': file.type,
        'Content-Disposition': `disposition; filename=${scrubFileName(file.name)}`,
      },
      body: file,
    }).then(res => {
      if(res.status < 300) {
        return signedParams.publicUrl;
      } else {
        throw res;
      }
    });
  }

  function scrubFileName(filename) {
    return filename.replace(/[^\w\d_\-\.]+/ig, '');
  }
}
