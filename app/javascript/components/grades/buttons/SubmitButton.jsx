import React from 'react';

const SubmitButton = ({onClick, className, text, iconClass}) => (
  <button onClick={onClick} className={`btn-primary btn text-white ${className}`}>
    {text} 
    <span className="icon"><i className={`${iconClass}`}></i></span>
  </button>
);

export default SubmitButton;
