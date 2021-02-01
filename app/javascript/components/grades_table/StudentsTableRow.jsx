import React, { Fragment } from 'react';
import _ from 'lodash/fp';

const fieldToString = (field) => {
  if (_.isNil(field)){
    return ""
  }

  return field;
}

const studentFullName = (student) => (
  `${fieldToString(student.name)} ${fieldToString(student.first_surname)} ${fieldToString(student.second_surname)}`
);

const markValueToString = (value) => (
  _.isNil(value) ? "" : value.toString()
);

const replaceDots = _.replace(',', '.');

const InputColumn = (props) => (
  <div className={`flex flex-col justify-center w-32 ${props.className}`}>
    <input 
      type="text" 
      maxLength={4}
      className="w-16 h-8 mx-auto block" 
      value={markValueToString(props.mark.value)} 
      onChange={(e) => {
        props.onValueChange({
          id: props.mark.id,
          remarkable_id: props.mark.remarkable_id,
          remarkable_type: props.mark.remarkable_type,
          student_id: props.mark.student_id,
          value: replaceDots(e.target.value),
        });
      }}/>
  </div>
);

const WithoutTerms = (props) => (
  <>
    {props.lessons.map((lesson) => (
      <InputColumn 
        key={lesson.lesson.id} 
        mark={lesson.mark}
        onValueChange={props.onValueChange}
      />
    ))}
    <InputColumn 
      mark={props.courseMark}
      onValueChange={props.onValueChange}
    />
  </>
);

const AllTerms = (props) => (
  <>
    {props.terms.map((term) => (
      <Fragment key={term.term.id}>
        {term.lessons.map((lesson) => (
          <InputColumn 
            key={lesson.lesson.id} 
            mark={lesson.mark}
            onValueChange={props.onValueChange}
          />
        ))}
        <InputColumn 
          key={term.term.id} 
          className="border-r border-gray-200" 
          mark={term.termMark}
          onValueChange={props.onValueChange}
        />
      </Fragment>
    ))}
    {props.lessons.map((lesson) => (
      <InputColumn 
        key={lesson.lesson.id}
        mark={lesson.mark}
        onValueChange={props.onValueChange}
      />
    ))}
    <InputColumn 
      mark={props.courseMark}
      onValueChange={props.onValueChange}
    />
  </>
);

const OneTerm = (props) => (
  <>
    {props.term.lessons.map((lesson) => (
      <InputColumn 
        key={lesson.lesson.id} 
        mark={lesson.mark}
        onValueChange={props.onValueChange}
      />
    ))}
    <InputColumn 
      mark={props.term.termMark}
      onValueChange={props.onValueChange}
    />
  </>
);

const StudentTableRow = (props) => (
  <div className="grades-table-row">
    <div className="flex flex-col justify-center w-40 border-r border-gray-200">
      <p className="text-lg font-semibold tracking-tight">
        {studentFullName(props.courseMember.student)}
      </p>
    </div>
    {props.isUndefined && (
      <WithoutTerms
        courseMark={props.courseMember.courseMark}
        lessons={props.courseMember.lessons} 
        onValueChange={props.onValueChange}
      />
    )}

    {!props.isUndefined && props.isAllTermsSelected && (
      <AllTerms 
        courseMark={props.courseMember.courseMark}
        terms={props.courseMember.terms} 
        onValueChange={props.onValueChange}
        lessons={props.courseMember.lessons}
      />
    )}

    {!props.isUndefined && !props.isAllTermsSelected && (
      <OneTerm 
        term={props.courseMember.terms[0]} 
        onValueChange={props.onValueChange}
      />
    )}

  </div>
);

export default StudentTableRow;
