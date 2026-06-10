const STATUS = {
  SLOT_TAKEN:   409,
  NOT_FOUND:    404,
  INVALID_DATE: 400,
};

// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, next) {
  console.error(err);
  const status = STATUS[err.code] ?? 500;
  res.status(status).json({
    error:   err.code    || 'INTERNAL_ERROR',
    message: err.message || 'Something went wrong',
  });
}

module.exports = errorHandler;
