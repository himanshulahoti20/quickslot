function requireUserId(req, res, next) {
  const header = req.headers['x-user-id'];
  if (!header) {
    return res.status(401).json({
      error:   'UNAUTHORIZED',
      message: 'X-User-Id header required',
    });
  }
  req.userId = parseInt(header, 10);
  next();
}

module.exports = requireUserId;
