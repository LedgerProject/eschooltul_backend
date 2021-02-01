import React from 'react';

const SubmitButton = (props) => (
  <button onClick={props.onClick} className={`btn-primary btn text-white ${props.colors}`}>
    {props.text} 
    <span className="icon"><i className={`${props.icon}`}></i></span>
  </button>
);

export default SubmitButton;
