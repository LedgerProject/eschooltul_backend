import React from 'react';

const Column = ({ className, name }) => (
  <div className={`flex flex-col ${className} w-32 max-w-32 min-w-32`}>
    <p className="text-center">{name}</p>
  </div>
);

export default Column;
