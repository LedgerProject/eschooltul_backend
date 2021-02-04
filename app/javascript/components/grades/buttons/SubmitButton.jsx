import React from 'react';

const SubmitButton = ({
  onClick,
  className,
  text,
  iconClass,
}) => (
  <button type="submit" onClick={onClick} className={`btn-primary btn text-white ${className}`}>
    {text}
    <span className="icon"><i className={`${iconClass}`} /></span>
  </button>
);

export default SubmitButton;
