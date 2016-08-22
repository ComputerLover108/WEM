def person_view(request, person_id=None):

    if person_id == None:

        person = Person()

    else:

        person = Person.objects.get(id = person_id)

    PhoneFormSet = inlineformset_factory(Person, Phone, can_delete=True)

    if request.method == "POST":

        personform = PersonForm(request.POST, instance=person)

        phoneformset = PhoneFormSet(request.POST, request.FILES, instance=person)

        if personform.is_valid() and phoneformset.is_valid():

            personform.save()

            phoneformset.save()

            # Redirect to somewhere

            if '_save' in request.POST:

                return HttpResponseRedirect('/admin/person/person/')

            if '_addanother' in request.POST:

                return HttpResponseRedirect('/admin/person/person/add/')

    else:

        personform = PersonForm(instance=person)

        phoneformset = PhoneFormSet(instance=person)

    return render_to_response('person.html', {

        'personform' : personform, 'phoneformset' : phoneformset, })

<fieldset class="module aligned ">

{% for field in personform %}

    <div class="form-row">

        <div class="field-box">

            {{ field.errors }}

            {{ field.label_tag }}: {{ field }} </div>

    </div>

{% endfor %}

</fieldset>

<fieldset class="module aligned ">

<h2>Phone Numbers</h2>

<table>

    <tr>

        {% for field in phoneformset.forms.0 %}

            {% if not field.is_hidden %}

                <th>{{ field.label }}</th>

            {% endif %}

        {% endfor %}

    </tr>

    {% for f in phoneformset.management_form %}

        {{ f }}

    {% endfor %}

    {% for f in phoneformset.forms %}

        <tr>

            {% for field in f %}

                {% if not field.is_hidden %}

                    <td>

                        {{ field.errors }}

                        {{ field }}

                    </td>

                {% else %}

                    <td valign="bottom">{{ field }}</

                {% endif %}

            {% endfor %}

        </tr>

    {% endfor %}

</table>

</fieldset>
