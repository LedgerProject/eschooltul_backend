
export default function ParsePrintable(courseMembers){
    var printable = new Array();

    courseMembers.forEach(courseMember => {
      const { student } = courseMember
      courseMember.terms.forEach(term => {
        term.lessons.forEach(lesson => {
        
          var newLine = {
            Student: student.name + " " + student.first_surname + " " + student.second_surname, 
            Term: term.term.name,
            Lesson: lesson.lesson.name,
            Mark: lesson.mark.value
          }
          
          printable.push(newLine)
        });
      });
    });

    return printable;
}