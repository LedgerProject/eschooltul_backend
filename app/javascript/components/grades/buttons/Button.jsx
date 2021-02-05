import React from 'react';

const Button = ({
  url,
  className,
  text,
  iconClass,
}) => (
  <a href={url} className={`btn-primary btn text-white ${className}`}>
    {text}
    <span className="icon"><i className={`${iconClass}`} /></span>
  </a>
);

export default Button;
