import React from 'react';

const Button = (props) => (
  <a href={props.url} className={`btn-primary btn text-white ${props.colors}`}>
    {props.text} 
    <span className="icon"><i className={`${props.icon}`}></i></span>
  </a>
);

export default Button;
