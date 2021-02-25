import React from 'react';

const IconSubmitButton = ({
  url,
  className,
  iconClass,
}) => (
  <a href={url} className={`btn-primary btn text-white ${className}`}>
    <span className="icon"><i className={`${iconClass}`} /></span>
  </a>
);

export default IconSubmitButton;
